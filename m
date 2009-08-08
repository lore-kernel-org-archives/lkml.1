Return-Path: <linux-kernel-owner+w=401wt.eu-S1752855AbZHHGZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbZHHGZV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 02:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbZHHGZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 02:25:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:37355 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbZHHGZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 02:25:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=W9cWsQu0ixQsJslEeLMZNoRMfHt/115NGo5WcSj8ozKH8/lboQ19KPQl7360W6CK7S
         0xqFOasRxfIc7bU6/bRwjNbdzoM2uKomuYHXdtzmyrhHUL7oq9uRwQ0sWOOJYskXRRY0
         ON+0uXo3YTQfaLzGm051qGPJIqW8jgOJFDCWo=
Date: Fri, 7 Aug 2009 23:25:15 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Ribeiro <drwyrm@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, eric.y.miao@gmail.com,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, openezx-devel@lists.openezx.org,
       Ilya Petrov <ilya.muromec@gmail.com>,
       Antonio Ospite <ospite@studenti.unina.it>
Subject: Re: [PATCH v3] input: PCAP2 misc input driver
References: <1249678456-15381-1-git-send-email-drwyrm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249678456-15381-1-git-send-email-drwyrm@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090808065526.F28A0526EC9@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 10:54:16PM +0200, Daniel Ribeiro wrote:
> This is a driver for misc input events for the PCAP2 PMIC, it handles
> the Power key and the Headphone button.
> 
> Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>
> Signed-off-by: Ilya Petrov <ilya.muromec@gmail.com>
> Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
> 

Acked-by: Dmitry Torokhov <dtor@mail.ru>

-- 
Dmitry
