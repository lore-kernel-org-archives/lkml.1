Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446AbYJ1NtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbYJ1NtJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 09:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbYJ1Ns4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 09:48:56 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:2246 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbYJ1Nsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 09:48:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=X7KbcgP0HDcGvZWNh7CwOlMq3oE4O2zj/443R5bAZd3HTnBHlZENgtac+2PeiAZBdG
         C0Tvrfk0JvJ0dTx8s1V4Yz8d6IkY9NPyDJMqqeo3nGa9uIXkxaK+ApiK10bmkxoHBr85
         qqMt6eGBiI7ip8SfuD8tVj2dAIYKYTSGDqwFA=
Message-ID: <40a4ed590810280648u2fc01a6dybfe3d5f49aa29f94@mail.gmail.com>
Date: Tue, 28 Oct 2008 14:48:53 +0100
From: "Zeno Davatz" <zdavatz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [sda] write cache: enabled, read cache:enabled: doesn't support DPO or FUA, sda:
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear List

After my latest git pull from

url = git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

I done

make silentoldconfig
make modules_install

copied the bzImage to /boot and ran lilo.

When I want to boot into 2.6.28-rc2 I get:

[sda] write cache: enabled, read cache:enabled: doesn't support DPO or FUA, sda:

Also see my screenshot:

http://farm4.static.flickr.com/3213/2980651545_de81680bf9_o.jpg

Thank you for your Feedback.

Best
Zeno
