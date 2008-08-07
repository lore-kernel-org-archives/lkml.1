Return-Path: <linux-kernel-owner+w=401wt.eu-S1752653AbYHGNDC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbYHGNDC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 09:03:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbYHGNCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 09:02:50 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:49862 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbYHGNCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 09:02:49 -0400
Message-ID: <f17812d70808070212r56a74c03va31869ff7f9ebc1@mail.gmail.com>
Date: Thu, 7 Aug 2008 17:12:09 +0800
From: "Eric Miao" <eric.y.miao@gmail.com>
To: "Marc Zyngier" <maz@misterjones.org>
Subject: Re: [PATCH 1/5] Basic support for the Arcom/Eurotech Viper SBC.
Cc: linux-kernel@vger.kernel.org,
       "Amit Walambe" <amit.walambe@eurotech-ltd.co.uk>
In-Reply-To: <20080807110720.1efe0608@not-of-this-earth.wild-wind.fr.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218028794-850-1-git-send-email-maz@misterjones.org>
	 <37f79c8da83c915c5ecc1d81cad9f4f5ae3c2b4a.1218018636.git.marc.zyngier@altran.com>
	 <f17812d70808062050r2a346b26ie31479b8d008417f@mail.gmail.com>
	 <20080807110720.1efe0608@not-of-this-earth.wild-wind.fr.eu.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> - People using their old user-space with a new kernel will see their
> serial port names shuffled (going from an all-ttyS? world to a mix of
> ttySA? and ttyS?). Is there a way to avoid the confusion?

This can be solved in user-space, "udev" is probably what you want.
