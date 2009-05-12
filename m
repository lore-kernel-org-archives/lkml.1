Return-Path: <linux-kernel-owner+w=401wt.eu-S1759390AbZELIlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759390AbZELIlL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 04:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756329AbZELIkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 04:40:53 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:5032 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070AbZELIkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 04:40:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=fVEUnXtBkIN/GaDB7wFtR5enmN+KlT/stDomlqhh2OipGm8B6DgHXo0TeKRslPpUo9
         gxeo8j/ZpFFzlUW1tVxtqvujACINIKCMCvCg5gNeIpoOcbG0E+JJnCQpwuocW8t8uTtk
         fmc46uTq2u0ZoH26U3HWPzxcvRm8tfZHQaVks=
MIME-Version: 1.0
Date: Tue, 12 May 2009 16:40:52 +0800
X-Google-Sender-Auth: ac6ff5dcd7ffb367
Message-ID: <2a27d3730905120140m21ca81d7t8206e657b02ffbfb@mail.gmail.com>
Subject: [PATCH 0/6] rapidio: adding memory mapping IO support and misc fixes
From: Li Yang <leoli@freescale.com>
To: akpm@linux-foundation.org, Kumar Gala <galak@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, mporter@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org,
       linuxppc-dev Development <linuxppc-dev@ozlabs.org>,
       Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a re-post of patch series which adds MMIO support to Linux
RapidIO and fixes a few nits.

- Leo
