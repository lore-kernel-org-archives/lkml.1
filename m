Return-Path: <linux-kernel-owner+w=401wt.eu-S934161AbZHEK0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934161AbZHEK0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 06:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934135AbZHEK0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 06:26:30 -0400
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:56472 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934117AbZHEK03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 06:26:29 -0400
From: Frans Pop <elendil@planet.nl>
To: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: BUG: spinlock bad magic on CPU#1, swapper/1
Date: Wed, 5 Aug 2009 12:26:28 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, Jiri Pirko <jpirko@redhat.com>
References: <200908051136.44908.elendil@planet.nl> <200908051150.53301.elendil@planet.nl> <4A7958D3.40206@gmail.com>
In-Reply-To: <4A7958D3.40206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908051226.29026.elendil@planet.nl>
X-OriginalArrivalTime: 05 Aug 2009 10:26:29.0362 (UTC) FILETIME=[31E2B520:01CA15B7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 August 2009, Eric Dumazet wrote:
> Ingo posted a fix
> http://marc.info/?l=linux-kernel&m=124945666109347&w=2

Thanks. I'd missed that mail.
