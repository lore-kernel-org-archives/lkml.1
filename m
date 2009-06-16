Return-Path: <linux-kernel-owner+w=401wt.eu-S937634AbZFPGJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937634AbZFPGJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936050AbZFPFyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:54:52 -0400
Received: from legaljet.webserversystems.com ([67.18.134.218]:35932 "EHLO
	compulab.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936333AbZFPFyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:54:50 -0400
Message-ID: <4A3733A4.2050109@compulab.co.il>
Date: Tue, 16 Jun 2009 08:54:44 +0300
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.16 (X11/20080907)
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Balaji Rao <balajirrao@openmoko.org>, Eric Miao <eric.miao@marvell.com>
Subject: Re: [PATCH] mfd: early init for MFD running regulators
References: <20090615162813.GE4094@sortiz.org>
In-Reply-To: <20090615162813.GE4094@sortiz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Samuel Ortiz wrote:
> From: Samuel Ortiz <sameo@linux.intel.com>
> 
> For MFDs running regulator cores, we really want them to be brought up early
> during boot.
> 
> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>

Acked-by: Mike Rapoport <mike@compulab.co.il>


