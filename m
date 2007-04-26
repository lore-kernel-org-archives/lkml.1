Return-Path: <linux-kernel-owner+w=401wt.eu-S1031356AbXDZROH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031356AbXDZROH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031362AbXDZROG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:14:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031355AbXDZRNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:13:55 -0400
Message-ID: <4630DDC2.2040705@sandeen.net>
Date: Thu, 26 Apr 2007 12:13:38 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org,
       xfs-masters@oss.sgi.com, xfs@oss.sgi.com, viro@zeniv.linux.org.uk
Subject: Re: 2.6.20.3 - possible recursive locking detected - in XFS
References: <200704251116.57737.jesper.juhl@gmail.com>	 <20070425233345.GN48531920@melbourne.sgi.com> <9a8748490704260317u211c244au3c5478ac02c12c43@mail.gmail.com>
In-Reply-To: <9a8748490704260317u211c244au3c5478ac02c12c43@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> On 26/04/07, David Chinner <dgc@sgi.com> wrote:

>> Known false positive - XFS doesn't have the annotations needed for
>> this yet; we've got a patch that will probably make it's way into 6.5.22 that
>> should fix most of these issues.

wow... 6.5.22.... do we really have to wait that long? :)

-Eric
