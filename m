Return-Path: <linux-kernel-owner+w=401wt.eu-S1422641AbXC2VtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422641AbXC2VtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 17:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934356AbXC2VtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 17:49:18 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:42203 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934354AbXC2VtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 17:49:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LfgXT0PP9RVRTLmb+tj7npgj+JXzOYOy2ufW+liePzlj5nbIbswXJOYlfL2M9hIXElnRbSzCv6GRQO9pnaSZtpmgpOrywMizI4Piyef53Qi+zYXndP+wtPg8fFDUbRwdOCJFykXEyInv7wB56Rh0IEtBQoGcSbpYHvHA2dGxlUU=
Message-ID: <a44ae5cd0703291449p1e8f75a2i68e9874362cef061@mail.gmail.com>
Date: Thu, 29 Mar 2007 14:49:14 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Len Brown" <lenb@kernel.org>
Subject: Re: 2.6.21-rc5-mm2 -- ACPI problems (lid switch broken, always shows running from AC, plugging in AC hangs machine)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
In-Reply-To: <a44ae5cd0703291335q1eff6661hf398dfca1db8e491@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0703281355h13f1bd70s9eb94092bfa9c3e@mail.gmail.com>
	 <a44ae5cd0703290100q1bb80390ke66333407bbeecfd@mail.gmail.com>
	 <20070329011503.00c89cb8.akpm@linux-foundation.org>
	 <200703291311.09893.lenb@kernel.org>
	 <a44ae5cd0703291314i6cd6cbaeo8ed0d7037b746cd5@mail.gmail.com>
	 <a44ae5cd0703291335q1eff6661hf398dfca1db8e491@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm.   I've reproduced these problems with vanilla 2.6.21-rc5, so the
latest acpi-git changes are off the hook.  I am currently trying to
reproduce the problems with 2.6.21-rc4.  I'll let you know how it
turns out.

       Miles
