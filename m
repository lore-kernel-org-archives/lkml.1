Return-Path: <linux-kernel-owner+w=401wt.eu-S933925AbZJIQ3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933925AbZJIQ3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 12:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933841AbZJIQ3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 12:29:23 -0400
Received: from kroah.org ([198.145.64.141]:33640 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933795AbZJIQ3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 12:29:23 -0400
Date: Fri, 9 Oct 2009 09:09:51 -0700
From: Greg KH <greg@kroah.com>
To: =?iso-8859-1?B?RnLpZOlyaWMgTC4gVy4=?= Meunier <fredlwm@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31: no login prompt
Message-ID: <20091009160951.GA2766@kroah.com>
References: <alpine.LNX.2.01.0909191941270.24796@pervalidus>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.2.01.0909191941270.24796@pervalidus>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 19, 2009 at 07:43:04PM -0300, Frédéric L. W. Meunier wrote:
> While booting 2.6.31, I don't get a login prompt after runlevel 
> 3:
> 
> Sep 19 18:31:25 pervalidus init: Id "c1" respawning too fast: disabled for 5 minutes
> Sep 19 18:31:25 pervalidus init: Id "c3" respawning too fast: disabled for 5 minutes
> Sep 19 18:31:25 pervalidus init: Id "c2" respawning too fast: disabled for 5 minutes
> 
> It works fine with 2.6.30.5.
> 
> What can be causing it ?

This should be fixed in 2.6.31.3, can you verify this?

thanks,

greg k-h
