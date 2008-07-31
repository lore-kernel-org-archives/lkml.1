Return-Path: <linux-kernel-owner+w=401wt.eu-S1754376AbYGaEpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376AbYGaEpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 00:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbYGaEo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 00:44:57 -0400
Received: from namei.org ([69.55.235.186]:33895 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750841AbYGaEo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 00:44:56 -0400
Date: Thu, 31 Jul 2008 14:43:34 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Gene Heskett <gene.heskett@gmail.com>
cc: linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
       Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: 2.6.27-rc1 + selinux new options = no httpd
In-Reply-To: <200807302254.26036.gene.heskett@gmail.com>
Message-ID: <Xine.LNX.4.64.0807311440100.17254@us.intercode.com.au>
References: <200807302254.26036.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008, Gene Heskett wrote:

> Greetings;
> 
> I just had to reboot backwards to 2.6.26 as I don't seem to be able to turn 
> off enough selinux stuff to allow apache (httpd) to run, on 2.6.27-rc1 it 
> cannot get perms to access its log files so it exits.

Which new options?

What AVC messages are you seeing?

Which distro are you using and what is the policy package version?

> Is there a specific fix for this?

This is the first I've heard of this.


- James
-- 
James Morris
<jmorris@namei.org>
