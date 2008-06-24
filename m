Return-Path: <linux-kernel-owner+w=401wt.eu-S1759285AbYFXKfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759285AbYFXKfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 06:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753820AbYFXKfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 06:35:05 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:16071 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732AbYFXKfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 06:35:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=bBCjfMI4tDch9R2i7U+ejlvNw447TqrvREdW1TNjFN63Y36uhkdow7aSA9QQwxKnBU
         BaLlmzrwyaeqIpOYyFPWL1Eq6ZaP9Ro8Ok8z3XVOl4BP3ClQBunVVjgIZUHS0JKE5Otc
         BZkjE1zvi5jIJ7vUW5URJvE1HaO5V1sS+JH/E=
Message-ID: <ca0148c30806240335t799ab518o2f7589f6d3282787@mail.gmail.com>
Date: Tue, 24 Jun 2008 13:35:02 +0300
From: "Matti Linnanvuori" <mattilinn@gmail.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com
Subject: [PATCH v1.2.31] wan: add driver retina
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch is on top of linux-next June 24:
http://pcidriver.googlegroups.com/web/retina-1.2.31.patch?hl=en&gda=IAodQEQAAAD13nxGN0cierCNeIeJfDX5xXkFPvbRgqL6oDt-R_zhlWG1qiJ7UbTIup-M2XPURDSCRcGQDyno6jchG3K2xOQpIvUJau0VvnTEe9ncJ6VTfQ&gsc=eDZaJAsAAADBvYu52m-YgWqvwRZy0wen

Change log:
Fixed ETH_ZLEN minimal packet size
Added mmap(2) interface description
