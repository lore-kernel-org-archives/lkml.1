Return-Path: <linux-kernel-owner+w=401wt.eu-S1760341AbZCYLlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760341AbZCYLlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 07:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760296AbZCYLk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 07:40:26 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:32799 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760303AbZCYLkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 07:40:25 -0400
Message-ID: <49CA1822.6050902@grupopie.com>
Date: Wed, 25 Mar 2009 11:40:18 +0000
From: Rui Santos <rsantos@grupopie.com>
Organization: GrupoPIE, Portugal SA
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: =?UTF-8?B?TWljaGFlbCBCw7xrZXI=?= <m.bueker@berlin.de>,
       linux-kernel@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
Subject: Re: 2.6.27.19 + 28.7: network timeouts for r8169 and 8139too
References: <200903041828.49972.m.bueker@berlin.de> <20090304224310.GA29043@electric-eye.fr.zoreil.com> <49B5066D.1030309@grupopie.com> <49BE4EF6.3030406@grupopie.com> <20090322211159.GA23042@electric-eye.fr.zoreil.com>
In-Reply-To: <20090322211159.GA23042@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu wrote:
> Can you see if one of the attached patches or a combination of them
> makes a difference for the current (-git) kernel ?
>   

I've concluded the tests. Unfortunately, the problem still remains.
However, with both, and only both patches applied, the connection speed
was higher and took longer, a lot longer to reproduce the problem but,
it did.


Regards,
Rui Santos

