Return-Path: <linux-kernel-owner+w=401wt.eu-S1755005AbZFUUcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005AbZFUUcS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 16:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbZFUUcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 16:32:09 -0400
Received: from ms.trustica.cz ([82.208.32.68]:59452 "EHLO ms.trustica.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbZFUUcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 16:32:08 -0400
Message-ID: <4A3E98BD.1090504@assembler.cz>
Date: Sun, 21 Jun 2009 22:31:57 +0200
From: Rudolf Marek <r.marek@assembler.cz>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Michael Riepe <michael.riepe@googlemail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [PATCH] Enable coretemp driver on Intel Atom
References: <49E7C34A.60007@googlemail.com> <20090618121326.42ab9c2f.akpm@linux-foundation.org> <4A3AAC01.7050805@googlemail.com>
In-Reply-To: <4A3AAC01.7050805@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

If someone has good contact at Intel, please do ask them to send a patch with 
correct TjMax (or Tcontrol) temperature for this CPU. This info was hard to get 
for the Core CPUs.

Thanks,
Rudolf
