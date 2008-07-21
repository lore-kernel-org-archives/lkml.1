Return-Path: <linux-kernel-owner+w=401wt.eu-S1754139AbYGUSfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbYGUSfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 14:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbYGUSfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 14:35:18 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:37847 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbYGUSfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 14:35:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=bZtx44tIrEBsol8PMNDVDI/1d47rhrcaiZj5rIQraeVFi29b7sHVwzgafCQ0VE0m/f
         q3lVAgE2oiKRJsEgOOaNMyvixu+1krm+6eHP4zPWC31zTeovxn/VYzz8Gvvsw7eJ+qU4
         lk6B4AfRi6LlLoTgfGnryp1faIh2kIPg6DPHw=
Message-ID: <b637ec0b0807211135u19659393x56605e936a0dce7d@mail.gmail.com>
Date: Mon, 21 Jul 2008 20:35:15 +0200
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Status of the radeonfb driver?
Cc: "Benjamin Herrenschmidt" <benh@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

The subject says it all, I think. I'm asking because my quite old
Radeon Mobility X700 ( 1002:5653) is still not supported in latest
Linus' GIT tree.
There were some patching floating around some months ago but they
lacked suspend/resume support. Are there any progress or patches to
test ?

Regards,
Fabio
