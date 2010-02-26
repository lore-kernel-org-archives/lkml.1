Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935944Ab0BZMYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 07:24:14 -0500
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:54227 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935899Ab0BZMYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 07:24:10 -0500
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Re: Memory management woes - order 1 allocation failures
Date: Fri, 26 Feb 2010 13:24:07 +0100
User-Agent: KMail/1.9.9
Cc: linux-mm@kvack.org
References: <201002261232.28686.elendil@planet.nl>
In-Reply-To: <201002261232.28686.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002261324.08078.elendil@planet.nl>
X-OriginalArrivalTime: 26 Feb 2010 12:24:08.0888 (UTC) FILETIME=[985FA380:01CAB6DE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 February 2010, Frans Pop wrote:
> As can be seen from the attached munin graph [1] the system has only 256
> MB memory, but that's quite normal for a simple NAS system.

Oops. Make that "only 128 MB".
