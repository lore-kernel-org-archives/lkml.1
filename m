Return-Path: <linux-kernel-owner+w=401wt.eu-S1752530AbZCIJEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbZCIJEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 05:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbZCIJEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 05:04:24 -0400
Received: from mail-ew0-f177.google.com ([209.85.219.177]:56670 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbZCIJEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 05:04:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YP9nchjyQCJ58rIGiWb6jG3wS9A+0swTEohOvKColWMPs5eS/LBkN7qFkIA+OHhe0H
         ls1M/3bhYAYdKUYARogxVH405twd3NW1Ktfh2Akx1gpMOlI3aaaLxTjEEJF3HI7BWi5R
         xroquQKE4SuZ0pcqMvHch+Sh7nj7/OLRLTonw=
MIME-Version: 1.0
In-Reply-To: <1236586097-3830-2-git-send-email-qingtao.cao@windriver.com>
References: <1236586097-3830-1-git-send-email-qingtao.cao@windriver.com>
	 <1236586097-3830-2-git-send-email-qingtao.cao@windriver.com>
Date: Mon, 9 Mar 2009 10:04:19 +0100
Message-ID: <36ca99e90903090204o20ae8021n1b7407ab0c049d27@mail.gmail.com>
Subject: Re: [v1 PATCH 1/8] EDAC: AMD8111 driver Kconfig & Makefile
From: Bert Wesarg <bert.wesarg@googlemail.com>
To: Harry Ciao <qingtao.cao@windriver.com>
Cc: linux-kernel@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 9, 2009 at 09:08, Harry Ciao <qingtao.cao@windriver.com> wrote:
> Introduce Kconfig and Makefile options for AMD8111 EDAC driver.
This is not git bisactable. this patch should be after 2/8 and 3/8.

Bert
