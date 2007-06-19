Return-Path: <linux-kernel-owner+w=401wt.eu-S933489AbXFSTRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933489AbXFSTRJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 15:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933328AbXFSTQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 15:16:56 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43184 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932567AbXFSTQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 15:16:55 -0400
Date: Tue, 19 Jun 2007 12:16:55 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Thomas Glanzmann <thomas@glanzmann.de>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: GIT Packages for Debian Etch
In-Reply-To: <20070619061300.GK16393@cip.informatik.uni-erlangen.de>
Message-ID: <Pine.LNX.4.64.0706191215570.7008@schroedinger.engr.sgi.com>
References: <20070618212524.GC16393@cip.informatik.uni-erlangen.de>
 <Pine.LNX.4.64.0706181617060.18601@schroedinger.engr.sgi.com>
 <20070619061300.GK16393@cip.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007, Thomas Glanzmann wrote:

> it already is. But Debian Etch is stable which means there will no newer
> version of git in Debian Etch. Currently it is 1.4.whatever. When the
> next stable release is released, which takes some time with Debian,
> there will be a newer version of git shipped with it. So for the moment
> you have to a few choices to live with when you use Debian stable:
> 
>         - Use the old git version 1.4
>         - Build a newer version yourself
>         - Use the backports or any other prebuild but up2date packages

The other choice that we developers usually make is to run either testing 
or unstable. "stable" is a synonym for obsolete ;-).

