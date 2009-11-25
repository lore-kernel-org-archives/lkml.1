Return-Path: <linux-kernel-owner+w=401wt.eu-S964949AbZKYNtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964949AbZKYNtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758618AbZKYNtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:49:18 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:32930 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758368AbZKYNtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:49:17 -0500
Subject: Re: [PATCHv2 1/3] twl4030-regulator: Add all TWL regulators to
 twreg_info
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>
Cc: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "De-Schrijver Peter (Nokia-D/Helsinki)" 
	<Peter.De-Schrijver@nokia.com>,
       "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>
In-Reply-To: <1259156290.6303.2.camel@keskisaa-workstation>
References: <1259143495-9480-1-git-send-email-ext-juha.1.keski-saari@nokia.com>
	 <1259143495-9480-2-git-send-email-ext-juha.1.keski-saari@nokia.com>
	 <1259156290.6303.2.camel@keskisaa-workstation>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Nov 2009 13:49:20 +0000
Message-ID: <1259156960.3697.74.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-25 at 15:38 +0200, Juha Keski-Saari wrote:
> Regrettably it seems I slipped a mistake into this patch which took out
> the regulators VAUX1-3. Below is a version which removes this issue
> 

Ah, I've just applied and pushed this series. Can you redo against
voltage for-next ?

Thanks

Liam



