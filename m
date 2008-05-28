Return-Path: <linux-kernel-owner+w=401wt.eu-S1751868AbYE1Qky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbYE1Qky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 12:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbYE1Qke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 12:40:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbYE1Qkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 12:40:33 -0400
Date: Wed, 28 May 2008 09:49:39 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.26rc4 GFS2 oops.
Message-ID: <20080528134939.GB29374@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Whitehouse <swhiteho@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20080527194420.GB14577@redhat.com> <1211974564.3635.585.camel@quoit>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211974564.3635.585.camel@quoit>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2008 at 12:36:04PM +0100, Steven Whitehouse wrote:
 > Hi,
 > 
 > On Tue, 2008-05-27 at 15:44 -0400, Dave Jones wrote:
 > > Single node GFS2 filesystem. Run fsx. Boom.
 > > 
 > I've tried it on -nmw and it seems to run ok, and I'm currently running
 > it on the current upstream kernel and its done 1/2 hour so far with no
 > sign of a problem.
 > 
 > Can you give a few more details, such as the block size of the fs

whatever the defaults that mkfs used. (unless anaconda did something funky,
which is unlikely).  [the box is switched off right now, and I'm not near it
so I can't check it easily].

 > , the
 > exact command line for fsx (I was just running with defaults)

same.  just "./fsx foo"

 > and
 > perhaps check all the info into a Red Hat bugzilla? I know this is
 > upstream, but I tend to use "Fedora/rawhide" to keep tabs on such things
 > just so as all the bugs are in the same place,

no problem.

	Dave 

-- 
http://www.codemonkey.org.uk
