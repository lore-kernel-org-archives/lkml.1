Return-Path: <linux-kernel-owner+w=401wt.eu-S1755532AbYG3T2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbYG3T2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 15:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbYG3T16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 15:27:58 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:7976 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbYG3T16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 15:27:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=USYYVI+hq6ZNpq7Mtz83SylOZW7zcRHHueoC5Z/FkZ/FE0KmUSL+dNqQZDF+nXog5Q
         uzAEywydSwi1pYNlcBu7ob9EpWOFuElPB2rXYFhfeNjcJtdfkhwhLdSl54z/NA6MLNjY
         J5aLFcc7bc1o6t4BNk4ZURD6xgv1xBdnZua9o=
Message-ID: <3aa654a40807301227r42db4409ubd94858e0618d15@mail.gmail.com>
Date: Wed, 30 Jul 2008 12:27:56 -0700
From: "Avuton Olrich" <avuton@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Compile time message 'nothing to be done for.`__fw_mod*`'
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm sure it's harmless, just in case no one has noticed yet, got a
compile time message right after linking modules:

make[1]: Nothing to be done for `__fw_modbuild'.

and another one right after installing them:

make[1]: Nothing to be done for `__fw_modinst'.

kernel: 660fc1f4d88b0f5e4bb936e4a5a9b95b70df9e58
http://anpmech.com/~sbh/lkml-config
-- 
avuton
--
 "I've got a fever. And the only prescription is more cowbell." --
Christopher Walken
