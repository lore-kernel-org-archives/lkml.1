Return-Path: <linux-kernel-owner+w=401wt.eu-S934906AbZDBKbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934906AbZDBKbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 06:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758111AbZDBKbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 06:31:36 -0400
Received: from mx1.emlix.com ([193.175.82.87]:37184 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757166AbZDBKbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 06:31:35 -0400
Message-ID: <49D49401.1090305@emlix.com>
Date: Thu, 02 Apr 2009 12:31:29 +0200
From: =?ISO-8859-1?Q?Daniel_Gl=F6ckner?= <dg@emlix.com>
Organization: emlix GmbH
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: Chris Zankel <chris@zankel.net>, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Johannes Weiner <jw@emlix.com>
Subject: Re: [patch 3/6] xtensa: add spi mmc host to s6105 platform
References: <1237822462-32109-1-git-send-email-dg@emlix.com> <1237822462-32109-3-git-send-email-dg@emlix.com> <200903241309.27310.david-b@pacbell.net>
In-Reply-To: <200903241309.27310.david-b@pacbell.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2009 09:09 PM, David Brownell wrote:
> Looks OK to me.  FWIW I don't expect to ack arch patches
> that just use public interfaces...

Then what do you think of patch 1/6 aka "spi: s6000 spi host driver"?

  Daniel

-- 
Dipl.-Math. Daniel Glöckner, emlix GmbH, http://www.emlix.com
Fon +49 551 30664-0, Fax -11, Bahnhofsallee 1b, 37081 Göttingen, Germany
Geschäftsführung: Dr. Uwe Kracke, Dr. Cord Seele, Ust-IdNr.: DE 205 198 055
Sitz der Gesellschaft: Göttingen, Amtsgericht Göttingen HR B 3160

emlix - your embedded linux partner
