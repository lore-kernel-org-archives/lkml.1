Return-Path: <linux-kernel-owner+w=401wt.eu-S1758565AbXKDK2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758565AbXKDK2t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 05:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755028AbXKDK2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 05:28:41 -0500
Received: from mu-out-0910.google.com ([209.85.134.191]:45873 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbXKDK2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 05:28:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=cXSOBAK4GxC5paW48vFPDMUcTlbO8chgLtlhWxZPE1I6dm0k+2gkyh7eHJepfjAqB6GV/U18ajcM7zlpXa2Aqp57ebLNRJRnj7/Lp9lawTwD6MXAgfsAuGkUK4uGIdTfVFoMktROV9cSBdLb3gtL/oRHUrGWcD2ofGyCEAtO16o=
Message-ID: <472D9ED3.6000202@gmail.com>
Date: Sun, 04 Nov 2007 11:28:35 +0100
From: drago01 <drago01@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
       kernel list <linux-kernel@vger.kernel.org>,
       ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] iwl3945 in 2.6.24-rc1 dies under load
References: <20071031005202.GA1534@elf.ucw.cz>	<1193792098.9704.16.camel@debian.sh.intel.com>	<20071101001221.GA1755@elf.ucw.cz>	<1193881026.31257.52.camel@debian.sh.intel.com> <20071103183446.GD13202@elf.ucw.cz>
In-Reply-To: <20071103183446.GD13202@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> BTW... the wireless light does not seem to work on x60. It used to
> work with some -mm versions...
>   
iwl3945 and ilw4965 don't support the wireless leds. There is a patch on 
this list that enables it but it is not merged yet.


