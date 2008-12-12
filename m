Return-Path: <linux-kernel-owner+w=401wt.eu-S1757773AbYLLPz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773AbYLLPz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 10:55:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758591AbYLLPzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 10:55:43 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:50238 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758379AbYLLPzl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 10:55:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=PbB0BcOofvPmoSpjYFuDem7ofy2lmioiBJp1aOrOkcR/YBuw5e5Sk9X/g65x4BsizQ
         Mmzh/nUXxNDERg/YiQOoIWXUoGj8OKhRR0J8E+6tWPrhdg9sYBU7ZGUyicic+s4OIZ4a
         ++y0lLl5Z7IenUthSI71WOI/qlyTyM4/S0QaI=
Message-ID: <f5cc88f60812120747w47c762a7qcee62fdfa10d6ac6@mail.gmail.com>
Date: Fri, 12 Dec 2008 13:47:36 -0200
From: "Marcello Henrique" <faraohh@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Auto generate .config.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

Is possible to generate .config automatically, for example: I use one
distribution with many modules a default for any distribution, however
I use only some of them. I want to optimize my kernel without select
all modules with make menuconfig. I want generate this file from just
run default kernel. This is possible?

How make to generate the file .config from my distribution to compile
new optimized kernel?

Thanks for any helps!
--
Marcello Henrique
Associação Software Livre de Goiás (www.aslgo.org.br)
Cercomp - UFG (www.cercomp.ufg.br)
