Return-Path: <linux-kernel-owner+w=401wt.eu-S1759648AbZFBFqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759648AbZFBFqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 01:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755865AbZFBFqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 01:46:04 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:28250 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbZFBFqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 01:46:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=Fs1yxtFxIBnOMJEtGzovyObq+gc+o0gPgYYEIt13UtX7CT0+J6yAs/s/p9eNu22MeB
         msvjDsDISZBGZj5h3R17F0D8PgBycSc10PmDuZbW8mm1P/b+P8gGA7+IiOiFTfVb9/em
         896DKGdG8si9OYkFHbflJ9rP0YwzOtAMyv7OQ=
MIME-Version: 1.0
Date: Mon, 1 Jun 2009 22:46:04 -0700
Message-ID: <d4029b2f0906012246r5ae64e99v9fff06726036b44f@mail.gmail.com>
Subject: bluez question
From: BlueZ Newbie <blueznewbie@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bluetooth experts,

I am trying to send SMS from my PC (linux bluez with a USB dongle) to
my cell phone via bluetooth. Please note that I do not intend to
"instruct my cell phone to send an SMS to another cell phone" via AT
commands - instead, I want to send SMS from my PC to my cell phone
such that my cell phone acts as though it received an SMS.

Is this possibel to do? If so, what type of protocols should I use
(RFCOMM?)? Can I do it programmatically?

Thanks,
Kumar
