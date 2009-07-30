Return-Path: <linux-kernel-owner+w=401wt.eu-S1751358AbZG3Oh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358AbZG3Oh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 10:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750997AbZG3OhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 10:37:25 -0400
Received: from colo3.heeltoe.com ([207.210.106.184]:42253 "EHLO
	colo3.heeltoe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbZG3OhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 10:37:25 -0400
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] forced recalibration for the OLPC hgpk touchpad 
From: Paul Fox <pgf@laptop.org>
In-reply-to: <20090730061803.C05C3526EC9@mailhub.coreip.homeip.net> (sfid-20090730_014410_549939_B9FD9B58) 
References: <3026.1243972079@foxharp.boston.ma.us> <29774.1248905330@foxharp.boston.ma.us> <20090730061803.C05C3526EC9@mailhub.coreip.homeip.net> (sfid-20090730_014410_549939_B9FD9B58)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <18564.1248964644.1@foxharp.boston.ma.us>
Date: Thu, 30 Jul 2009 10:37:24 -0400
Message-ID: <18567.1248964644@foxharp.boston.ma.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi dmitry --

dmitry wrote:
 > Sorry, I completely forgot about this patch... I am going to apply
 > it, however I think that we should not be creating the attribute
 > if the touchpad does not support recalibration. Also, I don't see
 > the reason why we can't schedule recalibration immediately instead
 > of waiting for 1 msec.
 > 
 > Could you please try updated version of the patch below?

looks and works fine.  thanks!

paul
=---------------------
 paul fox, pgf@laptop.org
