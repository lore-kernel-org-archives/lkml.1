Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbYJ3Kzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbYJ3Kzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 06:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754960AbYJ3Kz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 06:55:29 -0400
Received: from fmmailgate04.web.de ([217.72.192.242]:60825 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946AbYJ3Kz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 06:55:27 -0400
Date: Thu, 30 Oct 2008 11:54:57 +0100
Message-Id: <488434293@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Subject: how much license information inside the kernel ?
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX19F9ARCLxO0DmDoWACWpTRQ9LdSwHgXe1V9dE15x88aEl6WX
 8HEVnw5qMbNoSAQspimhXKdvldU/lntcpy4hlHs28w2id3SPa0=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi, 

i found that there is a LOT of repeating licensing information in the kernel.

for me, 

find ./linux-2.6.27 -type f -exec cat {} \; |egrep "free software|GNU General Public License|Free Software Foundation|version 2 of the License|distributed in the hope|WITHOUT ANY WARRANTY|FITNESS FOR A PARTICULAR"

gives a file sized ~3.5M

That`s more than 1% of the kernel source.

What about the idea to shorten that licening information to a minimum , e.g. by shrinking that to a single, catchy line ,  linking to a special licensing file like COPYING or linking to the FSF website ?

please no flames, i know this idea could be pure dynamite for some people - but i thought 3.5M is worth this mail.

regards
roland

ps:
i`m not sure if that has been discussed already, but i didn`t find that in the archive. please ignore, otherwise.
________________________________________________________________________
n 5 Schritten zur eigenen Homepage. Jetzt Domain sichern und gestalten! 
Nur 3,99 EUR/Monat! http://www.maildomain.web.de/?mc=021114

