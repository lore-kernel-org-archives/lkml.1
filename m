Return-Path: <linux-kernel-owner+w=401wt.eu-S1752460AbZLVIwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbZLVIwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 03:52:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbZLVIwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 03:52:13 -0500
Received: from senator.holtmann.net ([87.106.208.187]:50089 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbZLVIwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 03:52:12 -0500
Subject: Re: [PATCH 1/6] uwb/i1480: add __init/__exit macros
From: Marcel Holtmann <marcel@holtmann.org>
To: peterhuewe@gmx.de
Cc: David Vrabel <david.vrabel@csr.com>, Jiri Kosina <trivial@kernel.org>,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1261470431-23642-1-git-send-email-peterhuewe@gmx.de>
References: <1261470431-23642-1-git-send-email-peterhuewe@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Dec 2009 00:51:44 -0800
Message-Id: <1261471904.609.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

> Trivial patch which adds the __init/__exit macros to the module_init/
> module_exit functions of
> 
> uwb/i1480/i1480-est.c
> 
> @Jiri: As there is no maintainer, it seems it is up to you to decide :)

actually David Vrabel is taking care of the UWB subsystem and everything
related to it.

Regards

Marcel


