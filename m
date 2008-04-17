Return-Path: <linux-kernel-owner+w=401wt.eu-S933699AbYDQPx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699AbYDQPx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 11:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751224AbYDQPxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 11:53:49 -0400
Received: from namei.org ([69.55.235.186]:53655 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750833AbYDQPxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 11:53:49 -0400
Date: Fri, 18 Apr 2008 01:53:18 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Greg KH <greg@kroah.com>
cc: linux-security-module@vger.kernel.org, linux-audit@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/12] Tell git about security/selinux/include/audit.h
In-Reply-To: <20080417154433.GA2120@kroah.com>
Message-ID: <Xine.LNX.4.64.0804180152550.826@us.intercode.com.au>
References: <88d8811229b02f6b14ff1f0682dc5502a1f61b41.1208428765.git.jmorris@namei.org>
 <751bc5f7460a0337b7e463bd9a7c4ad60ed6176e.1208428766.git.jmorris@namei.org>
 <20080417154433.GA2120@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008, Greg KH wrote:

> On Thu, Apr 17, 2008 at 11:06:07AM +0000, James Morris wrote:
> > Signed-off-by: James Morris <jmorris@namei.org>
> > ---
> >  security/selinux/include/audit.h |   65 ++++++++++++++++++++++++++++++++++++++
> 
> Shouldn't this be merged with the previous patch that needed this?

Good thinking.


-- 
James Morris
<jmorris@namei.org>
