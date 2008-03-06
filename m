Return-Path: <linux-kernel-owner+w=401wt.eu-S934555AbYCFQ00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934555AbYCFQ00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 11:26:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932895AbYCFQ0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 11:26:13 -0500
Received: from ik-out-1112.google.com ([66.249.90.183]:9440 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759526AbYCFQ0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 11:26:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:x-enigmail-version:openpgp:content-type:content-transfer-encoding;
        b=mZih5ELVD8fY4O18g2o/jvNEu5KPN0LXMFyPzBtZyqYkDcTgaSzdMjNRyD4Tb2hm4ApjUFywR5J7UKwiEAmUyOBmGMn9aEnBRb3oqjGM0NPKbqCrUNDmUzRlUotPYyyyOpeOlwRZKLG2SI5bp9v6wSfLM1YbaJrPbVUqNCwEQbE=
Message-ID: <47D01ADF.3070705@gmail.com>
Date: Thu, 06 Mar 2008 17:25:03 +0100
From: Petr Susil <susil.petr@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Pavel Machek <pavel@ucw.cz>
Subject: driver for winbond wifi card on Kohjinsha subnotebook
X-Enigmail-Version: 0.95.6
OpenPGP: id=989390C9
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, i got a new kohjinsha laptop with winbond wifi card and I'm 
struggling to get it work...
I found a driver which seems to work somehow, but the driver is pretty 
buggy...
it causes kernel panic (when modprobing with wifi switched on) pretty 
often... (when modprobing with wifi switched off, the card does not work)
however if modprobing succeeds (about 10% times), the driver works 
pretty well...
the driver seems to be GPL, but the license version is unclear...
you can find some more info on my kohjinsha page: 
http://atrey.karlin.mff.cuni.cz/~susa/kohjinsha.html

