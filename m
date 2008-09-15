Return-Path: <linux-kernel-owner+w=401wt.eu-S1756387AbYIOU72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387AbYIOU72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 16:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754753AbYIOU7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 16:59:18 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:12289 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbYIOU7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 16:59:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=lB9HSOeQxhI8bTPSQfqjTR46ifygQGaoCRmDMby92promHyQDwb+qdwy08urvAlwBI
         NL6KcRlordFfx5fh4Kn7HRgosI2V0p5U4Am31FSXWqICBrN09mZqlGlEdxpJfwYIEFqp
         aquPJiPxSGMqT9ERSoYyoTBjNIZJJtEEThQJ4=
Message-ID: <43e72e890809151359n45c5ecdateff5a4eed3f4067e@mail.gmail.com>
Date: Mon, 15 Sep 2008 13:59:16 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>,
       "Michael Wu" <flamingice@sourmilk.net>
Subject: adm8211 driver usage
Cc: "Jouni Malinen" <j@w1.fi>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just curious, anyone using the adm8211 driver? My understanding was
there was not much hardware out -- if any at all -- for it. If no one
is using it maybe we can remove it. I don't know a single soul using
it except maybe Michael and maybe a year ago.

  Luis
