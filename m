Return-Path: <linux-kernel-owner+w=401wt.eu-S1764654AbXHJITA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764654AbXHJITA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 04:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764252AbXHJISk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 04:18:40 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:47596 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764243AbXHJISi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 04:18:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uSlc12lpkazMRj/KQ3WeV1ciCynZ6Zok1ysEqjr89G92jLoLrW47lT2PwQiQq9jIeazz3t6mZ5AbnYN/MIFQGlnQiL15SF7oKE1d19uVh0r9NAVVEXljEh1/ZVijZM+xJPsUFxcBb19t1xnNrWBe5fsLyO/8oF+CzVw+L5ri/xU=
Message-ID: <a8e1da0708100118r779068i64ffdc11e452be9b@mail.gmail.com>
Date: Fri, 10 Aug 2007 16:18:38 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc2-mm2
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070809224254.11f42716.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070809224254.11f42716.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
2.6.23-rc2-mm2:
config with CONFIG_NF_CONNTRACK_AMANDA=y
boot  oops:

hand copyed :
the EIP: helper_hash

backtrace:
do_basic_setup
...
nf_conntrack_amanda_init
error_code
do_vivide_error
...

Regards
dave
