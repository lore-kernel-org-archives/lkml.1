Return-Path: <linux-kernel-owner+w=401wt.eu-S1756801AbYDBN1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbYDBN1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 09:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756305AbYDBN1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 09:27:22 -0400
Received: from hpsmtp-eml14.kpnxchange.com ([213.75.38.114]:20316 "EHLO
	hpsmtp-eml14.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756277AbYDBN1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 09:27:21 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-ide@vger.kernel.org
Subject: Re: No IDE drivers loaded for Toshiba Satellite 320 CDS
Date: Wed, 2 Apr 2008 15:27:18 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
References: <200804021524.27222.elendil@planet.nl>
In-Reply-To: <200804021524.27222.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804021527.19367.elendil@planet.nl>
X-OriginalArrivalTime: 02 Apr 2008 13:27:19.0394 (UTC) FILETIME=[4698B420:01C894C5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 April 2008, Frans Pop wrote:
> We've received an installation report for Debian for an older system
> where no IDE driver gets loaded. The system does not have any IDE device
> listed in lspci. When ide-generic is modprobed manually, both the CD and
> hard disk work fine.

Forgot to mention that the kernel used was 2.6.22. A retry with 2.6.24 
should be possible if needed.
