Return-Path: <linux-kernel-owner+w=401wt.eu-S1759735AbYJVVLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759735AbYJVVLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 17:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754892AbYJVVLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 17:11:08 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:37819 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271AbYJVVLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 17:11:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=qyT5FAEkgKSTx2QnCKmJOXD5SUFqta1rxEEHgRAZFUtFrGy5Smr6ucFpdLdvfnnSoq
         lLl3dzJRTQyr21yH/ojA+blAO05KsQkiSroU/4hERI+qqVsbiHkZ1Uhu+PnfHV7vpzK4
         sRIb18SXXGKzBCdr8uh9gmG0Jci/Bm7/5t/7g=
Message-ID: <d9def9db0810221411r45ac7404pdfe5d2cf0266c088@mail.gmail.com>
Date: Wed, 22 Oct 2008 23:11:03 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       em28xx <em28xx@mcentral.de>
Subject: [PATCH 7/7] adding common used headers
Cc: acano@fastmail.fm, "Andre Kelmanson" <akelmanson@gmail.com>,
       "Bouwsma Barry" <freebeer.bouwsma@gmail.com>,
       "Dan Kreiser" <kreiser@informatik.hu-berlin.de>,
       "Frank Neuber" <fn@kernelport.de>,
       "Jelle de Jong" <jelledejong@powercraft.nl>,
       "John Stowers" <john.stowers.lists@gmail.com>,
       "Lukas Kuna" <lukas.kuna@evkanet.net>,
       "Stefan Vonolfen" <stefan.vonolfen@gmail.com>,
       "Stephan Berberig" <s.berberig@arcor.de>,
       "Thomas Giesecke" <thomas.giesecke@ibgmbh-naumburg.de>,
       "Vitaly Wool" <vwool@ru.mvista.com>, "Zhenyu Wang" <zhen78@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    tunerchip.h:
    just contains an internal used struct which can be used for
setting up a tuner frontend.
