Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbZK3MwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbZK3MwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 07:52:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbZK3MwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 07:52:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60366 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296AbZK3Mv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 07:51:59 -0500
Message-ID: <4B13BFF3.60607@redhat.com>
Date: Mon, 30 Nov 2009 14:52:03 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: host a git archive on an rsync server?
References: <20091130082032.GS10640@bicker>
In-Reply-To: <20091130082032.GS10640@bicker>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2009 10:20 AM, Dan Carpenter wrote:
> Could someone do a git clone and put it on an rsync server for me?
>
>    

http://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git/

and use some downloaded which supports resuming interrupted downloads.

-- 
error compiling committee.c: too many arguments to function

