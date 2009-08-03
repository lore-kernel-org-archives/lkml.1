Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbZHCQuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbZHCQuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 12:50:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbZHCQuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 12:50:14 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:49477 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbZHCQuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 12:50:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=ig6ISgESoj78PRE5+ldjXRlBJ7AHGmMSOYSt1VRpYxFMc5XXJwyybuG64k3qXq05CZ
         Ug4aeTU1oREzv+q39v8lT7tYMd7NLA8REnkwEP0lFYjYKmie0TS79sR2io+eV27FAxxc
         ggSF20tnLFWRpoiQGaC7QGjDQEKahs4eq4xSM=
MIME-Version: 1.0
Date: Mon, 3 Aug 2009 09:50:13 -0700
Message-ID: <689eb3470908030950j48c050c7lf243d7c0fc283c49@mail.gmail.com>
Subject: Printing process list
From: Anupama Chandwani <anupama.chandwani@gmail.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am trying to walk through the process list using for_each_process() macro.
However, I do not see all the processes in the list. "ps" shows me
many more processes.

Is there something I am missing?

-- 
Regards,
Anupama
