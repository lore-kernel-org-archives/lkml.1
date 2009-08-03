Return-Path: <linux-kernel-owner+w=401wt.eu-S1755338AbZHCPvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbZHCPvJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 11:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbZHCPvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 11:51:08 -0400
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:49973 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755185AbZHCPvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 11:51:07 -0400
From: Frans Pop <elendil@planet.nl>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH] Switch atmel_serial to dev_pm_ops
Date: Mon, 3 Aug 2009 17:51:04 +0200
User-Agent: KMail/1.9.9
Cc: albin.tonnerre@free-electrons.com, nicolas.ferre@atmel.com,
       linux@maxim.org.za, linux-kernel@vger.kernel.org,
       albin.tonnerre@free-electrons.com
References: <1249310347-22291-1-git-send-email-albin.tonnerre@free-electrons.com> <1249310347-22291-1-git-send-email-albin.tonnerre@free-electrons.com> <20090803170947.2f199b93@hskinnemoen-d830>
In-reply-To: <20090803170947.2f199b93@hskinnemoen-d830>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908031751.06681.elendil@planet.nl>
X-OriginalArrivalTime: 03 Aug 2009 15:51:07.0115 (UTC) FILETIME=[36B473B0:01CA1452]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haavard Skinnemoen wrote:
> Other than that,
> Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

Just to make sure...

Does this driver need to support hibernation (suspend to disk)? If it 
does, the patch is incomplete; see http://lkml.org/lkml/2009/7/25/118.

Cheers,
FJP
