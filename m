Return-Path: <linux-kernel-owner+w=401wt.eu-S1758626AbZCWPh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626AbZCWPh7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 11:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755559AbZCWPhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 11:37:50 -0400
Received: from mx1.emlix.com ([193.175.82.87]:56000 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536AbZCWPht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 11:37:49 -0400
Message-ID: <49C7ACCA.2080602@emlix.com>
Date: Mon, 23 Mar 2009 16:37:46 +0100
From: =?ISO-8859-15?Q?Daniel_Gl=F6ckner?= <dg@emlix.com>
Organization: emlix GmbH
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Chris Zankel <chris@zankel.net>,
       David Brownell <dbrownell@users.sourceforge.net>
CC: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [patch 5/6] xtensa: enable s6000 spi host in s6105_defconfig
References: <1237822462-32109-1-git-send-email-dg@emlix.com> <1237822462-32109-5-git-send-email-dg@emlix.com>
In-Reply-To: <1237822462-32109-5-git-send-email-dg@emlix.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"

On 03/23/2009 04:34 PM, Daniel Glöckner wrote:
> ---
>  arch/xtensa/configs/s6105_defconfig |   20 +++++++++++++++++++-
>  1 files changed, 19 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/xtensa/configs/s6105_defconfig b/arch/xtensa/configs/s6105_defconfig
> index e398710..02bab6e 100644

Signed-off-by: Daniel Glöckner <dg@emlix.com>


-- 
Dipl.-Math. Daniel Glöckner, emlix GmbH, http://www.emlix.com
Fon +49 551 30664-0, Fax -11, Bahnhofsallee 1b, 37081 Göttingen, Germany
Geschäftsführung: Dr. Uwe Kracke, Dr. Cord Seele, Ust-IdNr.: DE 205 198 055
Sitz der Gesellschaft: Göttingen, Amtsgericht Göttingen HR B 3160

emlix - your embedded linux partner
