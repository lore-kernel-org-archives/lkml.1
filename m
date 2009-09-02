Return-Path: <linux-kernel-owner+w=401wt.eu-S1751704AbZIBLUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704AbZIBLUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 07:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbZIBLUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 07:20:32 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:43092 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbZIBLUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 07:20:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=IIExbPTT3YbVeNLLJuo0+9MgmEygUe6ZP7mddtVNOfWvApOLEe2iyceBpKNsxPQJme
         fq7fshiqTfnIw1RiYpu1bPaIEI/QANlft1zXa7Qn6/d714hxYjMeQEiiSKAZ5k9//wzE
         H/AYGCNEYxmzHWk4g4iA5fL39zkHZBkWWYqrs=
Message-ID: <4A9E5503.3070708@gmail.com>
Date: Wed, 02 Sep 2009 13:20:35 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.1) Gecko/20090715 SUSE/3.0b3-8.4 Thunderbird/3.0b3
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
CC: Roland Dreier <rolandd@cisco.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: async_tx.git#fixes status
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

do you plan to push async_tx.git#fixes to upstream soon? Namely, we're
interested in Roland's "Add MODULE_DEVICE_TABLE() so ioatdma module is
autoloaded" patch. I don't see it even in -next so far.

Thanks.
