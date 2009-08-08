Return-Path: <linux-kernel-owner+w=401wt.eu-S1752694AbZHHGYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbZHHGYA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 02:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbZHHGX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 02:23:59 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:37787 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbZHHGX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 02:23:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=hcdhxk4Izu1rIFAoXU6IU7J5xMVtkm7DaCi8mBbzkA7B7IOGBMr6E24q8EShX538jd
         alhA3BEg0jPzaPU8Pe3WBqH1Gj5krPCyOygM5tU7g6GL7IUbhgYiDG6+OUMO59zE9B5o
         oLR9AHJD/ww4173i2VfDO++n68vU+A0AOwYGQ=
Date: Fri, 7 Aug 2009 23:23:52 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Ribeiro <drwyrm@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, eric.y.miao@gmail.com,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, openezx-devel@lists.openezx.org,
       Stefan Schmidt <stefan@datenfreihafen.org>,
       Antonio Ospite <ospite@studenti.unina.it>
Subject: Re: [PATCH v3] input: PCAP2 based touchscreen driver
References: <1249678496-15485-1-git-send-email-drwyrm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249678496-15485-1-git-send-email-drwyrm@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090808065404.C0309526EC9@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 10:54:56PM +0200, Daniel Ribeiro wrote:
> Touchscreen driver for the PCAP2 multi function device used in
> Motorola EZX smartphones.
> 
> Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>
> Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
> Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
> 

Acked-by: Dmitry Torokhov <dtor@mail.ru>

-- 
Dmitry
