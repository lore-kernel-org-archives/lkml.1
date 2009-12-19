Return-Path: <linux-kernel-owner+w=401wt.eu-S1751395AbZLSKOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395AbZLSKOf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 05:14:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbZLSKOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 05:14:34 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:51353 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbZLSKOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 05:14:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=GykMx+QVhEqC1mZuKtRJzI5mKvcpNrqOcZMwztqKIlVRjw+IcZZzPOHWAHvsibL24r
         9RoVNRZQbXbi50JGYO5BqIixrw4LT2vSw65IkIS66AydcvpUTaJm5uDs5fJ0HPB+09WO
         y47siMp3SnBIYCG8EFuep3ybgKPV8FHsiJA7Y=
MIME-Version: 1.0
Date: Sat, 19 Dec 2009 18:14:33 +0800
Message-ID: <8e678d3f0912190214s7ffbc3can784e8c907a6fe97@mail.gmail.com>
Subject: Can not generate ALSA driver documentation via Makefile
From: Robin Steven <armrobin@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, guy:

I am hacking ALSA driver for my customized board, and want to study
the document "writing_an_alsa_driver" in
"Documentation/sound/alsa/DocBook", in the top directory of kernel
source and run:

$ make htmldocs

I can get all the html format document in "Documentation/DocBook", and
no any html document in
"Documentation/sound/alsa/DocBook" was converted for .tmpl to html.

Thanks in advenced for any one can give me any idea!

= Robin
