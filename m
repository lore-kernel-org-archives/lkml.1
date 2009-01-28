Return-Path: <linux-kernel-owner+w=401wt.eu-S1753249AbZA1XB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbZA1XB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:01:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbZA1XBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:01:18 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:39283 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbZA1XBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:01:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=F7E0XrRi9aGdyd9wDIKNx9uCY9z3n6NO/RyylwRQC0S2ejEhCSDYnIpOUZ3Bxf5NZ8
         jh0xaqL17CRAoFQrlrlUWBGEyBX6FyTnFgyR4z2PteKlhu8Yrsh1I8Q68eDPkoRZRGN3
         Kc9srkQZQEo4ocrhpWkpbHd5lISWeveNkeQ7w=
Subject: Re: [PATCH] - UV fix compile error on IA64 & eliminate compiler
 warning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jack Steiner <steiner@sgi.com>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
In-Reply-To: <20090128212104.GA1156@sgi.com>
References: <20090128212104.GA1156@sgi.com>
Content-Type: text/plain
Date: Wed, 28 Jan 2009 15:01:14 -0800
Message-Id: <1233183674.6717.69.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-28 at 15:21 -0600, Jack Steiner wrote:
> Also eliminate a warning message in uv.h.

Which was....?

Harvey

