Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbYCMNp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbYCMNp6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 09:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbYCMNpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 09:45:50 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:37073 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbYCMNpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 09:45:50 -0400
Date: Thu, 13 Mar 2008 14:45:39 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: Chr <chunkeey@web.de>
cc: Samuel Tardieu <sam@rfc1149.net>,
       device-mapper development <dm-devel@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: INFO: task mount:11202 blocked for more than 120 seconds
In-Reply-To: <alpine.DEB.1.00.0803130003110.5593@sheep.housecafe.de>
Message-ID: <alpine.DEB.1.00.0803131444480.7433@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <20080309213441.GQ155407@sgi.com> <2008-03-12-19-03-51+trackit+sam@rfc1149.net> <200803122053.13265.chunkeey@web.de> <alpine.DEB.1.00.0803130003110.5593@sheep.housecafe.de>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008, Christian Kujau wrote:
> Hm, -git17 locked up hard when trying to access the device mapper

and so does -git8 and -git9...sigh :(

C.
-- 
BOFH excuse #412:

Radial Telemetry Infiltration
