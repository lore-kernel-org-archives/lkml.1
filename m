Return-Path: <linux-kernel-owner+w=401wt.eu-S1755966AbZEPL6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbZEPL6m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 07:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbZEPL63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 07:58:29 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:62773 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbZEPL61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 07:58:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=JbvrAbxm6G8CwYemKRQIbA1oq5a5lwkXcKCM/T1EHW1ZShUm9iBc8B99/2YwA7PtOO
         hYt/+CY3m0qVunGjN2fxKF13M6WJNRlC3LwYWFjwWZxFDFUHJ32b0CSLYPiW0m+5G9PB
         KbSBzMefFzw/HRNme94K/RLptQ+xXoWRql98o=
MIME-Version: 1.0
Date: Sat, 16 May 2009 17:28:28 +0530
Message-ID: <f5a7b3810905160458if6ce50en5079fc7f877484ee@mail.gmail.com>
Subject: quotactl ERANGE man page update
From: naresh kamboju <naresh.kernel@gmail.com>
To: jack@suse.cz
Cc: mtk-manpages@gmx.net, linux-kernel@vger.kernel.org,
       naresh.kernel@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Regarding the quota system call man page update,


I have noticed changes in recent kernels
Linux/fs/quota/ dquot.c under function name
static int do_set_dqblk(struct dquot *dquot, struct if_dqblk *di)
ERANGE error check has been added.

So could you update the quotactl man page w.r.t if_dqblk.dqb_valid



Best wishes,
Naresh Kamboju
