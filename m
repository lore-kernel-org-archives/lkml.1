Return-Path: <linux-kernel-owner+w=401wt.eu-S1752943AbZGXPAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbZGXPAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 11:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbZGXPAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 11:00:20 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:49323 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbZGXPAT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 11:00:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=CRwR0HkqpBSYyXY8TawNf2/yl9+fzL5UpabAuH23lz8GLf/A6M5x5VzROXpskOYBtJ
         2NBg+frc/QXvmGXKsdQF+BB7j/DX6J+e1UGZf8ZkOQ+53hoSNscO1+ZnZ3Qed4aiRvPu
         4uXC4kk/7UQ2qVy/1K0PgEYdU8fyTDdkD4RpY=
From: Diego Calleja <diegocg@gmail.com>
To: Clemens Eisserer <linuxhippy@gmail.com>
Subject: Re: Status of ext4 online defrag?
Date: Fri, 24 Jul 2009 17:00:24 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc3-00281-g3c33010-dirty; KDE/4.2.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <194f62550907240636o5ba623cdy1f16deb7f6d70eeb@mail.gmail.com>
In-Reply-To: <194f62550907240636o5ba623cdy1f16deb7f6d70eeb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200907241700.24170.diegocg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Viernes 24 Julio 2009 15:36:53 Clemens Eisserer escribió:
> Hello,
> 
> Does anybody know what the current state of ext4 online defrag is?

It got merged for 2.6.31 (commit 748de6736c1e482e111f9d1b5a5d5b1787600cad)
