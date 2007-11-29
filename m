Return-Path: <linux-kernel-owner+w=401wt.eu-S1761871AbXK2JML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761871AbXK2JML (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 04:12:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756068AbXK2JL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 04:11:56 -0500
Received: from rn-out-0910.google.com ([64.233.170.189]:35109 "EHLO
	rn-out-0102.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755945AbXK2JLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 04:11:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=k06zF5d8vd9DzUqpnS69ZFpGgMIzfYkO5RXt6SLJS/hTZQPtPA4OIOzzA6c4rMu17qRCveEeyB7lZtgwOThSpYJsYmjNcw+DeMDI4G8LfFNm3UmobG0fIN731c/CAcg5cGSQqqkv/4nRzryzkTJIyxuBFwM1Op8hwJmImgIMfSc=
Message-ID: <a8e1da0711290111m65b071cft90b4361ec0155096@mail.gmail.com>
Date: Thu, 29 Nov 2007 17:11:52 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: lenb@kernel.org
Subject: pnpacpi : exceeded the max number of IO resources
Cc: linux-acpi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
The pnpacpi rsparser.c report warnings of:
exceeded the max number of IO resources: 24

dmesg|grep exceeded|wc
    66     594    3564

Regards
dave
