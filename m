Return-Path: <linux-kernel-owner+w=401wt.eu-S1753717AbZDLUHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbZDLUHH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 16:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbZDLUGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 16:06:55 -0400
Received: from mail-gx0-f160.google.com ([209.85.217.160]:62125 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbZDLUGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 16:06:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MBuJGtWp+0pVzwbBCJN5SrbwfVrKDfmKQznn+qqu0Bs9EfdETxR9bEGNWuR2hBBsth
         cWOEUDVj+cZJB2xBZmuN448q44XTsZTVz6/EGBLDO6UdWArrTg5uIplKhc9UdAAEQHp7
         s/taiw2t+DG/1Tez9jHddpEiWBGPR8ze+93u8=
MIME-Version: 1.0
In-Reply-To: <1239565351-8085-1-git-send-email-m.kozlowski@tuxland.pl>
References: <1239565351-8085-1-git-send-email-m.kozlowski@tuxland.pl>
Date: Sun, 12 Apr 2009 16:06:52 -0400
Message-ID: <8bd0f97a0904121306le3b2becwc652525128a4c855@mail.gmail.com>
Subject: Re: [PATCH] fix parentheses balance in blackfin arch code
From: Mike Frysinger <vapier.adi@gmail.com>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: cooloney@kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, i've merged this into the Blackfin tree
-mike
