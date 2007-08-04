Return-Path: <linux-kernel-owner+w=401wt.eu-S1762105AbXHDAtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762105AbXHDAtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 20:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758869AbXHDAtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 20:49:05 -0400
Received: from dsl081-085-152.lax1.dsl.speakeasy.net ([64.81.85.152]:42971
	"EHLO moonbase.phunq.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757209AbXHDAtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 20:49:03 -0400
From: Daniel Phillips <phillips@phunq.net>
To: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: Distributed storage.
Date: Fri, 3 Aug 2007 17:49:00 -0700
User-Agent: KMail/1.9.5
Cc: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20070731171347.GA14267@2ka.mipt.ru> <170fa0d20708022109s60ebb85aqe68ec1033634ef27@mail.gmail.com>
In-Reply-To: <170fa0d20708022109s60ebb85aqe68ec1033634ef27@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708031749.00900.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Thursday 02 August 2007 21:09, Mike Snitzer wrote:
> But NBD's synchronous nature is actually an asset when coupled with
> MD raid1 as it provides guarantees that the data has _really_ been
> mirrored remotely.

And bio completion doesn't?

Regards,

Daniel
