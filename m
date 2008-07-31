Return-Path: <linux-kernel-owner+w=401wt.eu-S1756440AbYGaOot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbYGaOot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 10:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbYGaOog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 10:44:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbYGaOof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 10:44:35 -0400
Subject: Re: 2.6.27-rc1 + selinux new options = no httpd
From: Eric Paris <eparis@redhat.com>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>
In-Reply-To: <200807310909.27619.gene.heskett@gmail.com>
References: <200807302254.26036.gene.heskett@gmail.com>
	 <Xine.LNX.4.64.0807311440100.17254@us.intercode.com.au>
	 <200807310909.27619.gene.heskett@gmail.com>
Content-Type: text/plain
Date: Thu, 31 Jul 2008 10:44:14 -0400
Message-Id: <1217515455.2902.94.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-31 at 09:09 -0400, Gene Heskett wrote:
> On Thursday 31 July 2008, James Morris wrote:

> >What AVC messages are you seeing?
> 
> I posted the whole screen from setroubleshoot earlier.

I'm sorry but I can't seem to find it in your original message...

http://marc.info/?l=linux-kernel&m=121747333012971&w=2

Do you have another pointer?  I can't think of anything that went into
2.6.27 related to SELinux that should have in any way changed file
access checks but I'll poke through the changelog and see if something
stands out...

-Eric

