Return-Path: <linux-kernel-owner+w=401wt.eu-S1751935AbZIYRR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbZIYRR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 13:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbZIYRR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 13:17:57 -0400
Received: from 195-23-16-24.net.novis.pt ([195.23.16.24]:46753 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbZIYRR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 13:17:57 -0400
X-Greylist: delayed 3782 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Sep 2009 13:17:56 EDT
Message-ID: <4ABCEC77.70705@grupopie.com>
Date: Fri, 25 Sep 2009 17:14:47 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Diego_Elio_=27Flameeyes=27_Petten=F2?= 
	<flameeyes@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix build with KALLSYMS disabled.
References: <1253894312-17663-1-git-send-email-flameeyes@gmail.com>
In-Reply-To: <1253894312-17663-1-git-send-email-flameeyes@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Diego Elio 'Flameeyes' Pettenò wrote:
> With KALLSYMS disabled, but some debug features enabled, build will fail
> because the layout_symtab function uses the wrong type for ELF headers, and
> some variables are not declared. Fix that.

Hi, Diego

Thanks for the patch, but it seems it arrived about 12 hours too late ;)

http://lkml.org/lkml/2009/9/24/558

-- 
Paulo Marques - www.grupopie.com

"Very funny Scotty. Now beam up my clothes."
