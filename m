Return-Path: <linux-kernel-owner+w=401wt.eu-S1753126Ab0ALHBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab0ALHBP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 02:01:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402Ab0ALHBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 02:01:14 -0500
Received: from m50-111.126.com ([123.125.50.111]:59222 "EHLO m50-111.126.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979Ab0ALHBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 02:01:14 -0500
X-Greylist: delayed 1876 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Jan 2010 02:01:13 EST
Message-ID: <4B4C16CA.4010401@126.com>
Date: Tue, 12 Jan 2010 14:29:30 +0800
From: "Figo.zhang" <figo1802@126.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091215 Shredder/3.0
MIME-Version: 1.0
To: gregkh@suse.de, hjanssen@microsoft.com, haiyangz@microsoft.com,
       torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org
Subject: [staging/hv] why it not follow kernel codingstyle?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: jtKowLB7YyPRFkxLAC0xAQ--.16429S2
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUeA7k042IE42xK82IY6r45ZwAYjxAI6xAI
	w28IcVAK0I8IjxAxM7k042IE4IxYO2xFxVAqjxCEw4Av424lb7Iv0xC_Jr1lb4IE77IF4w
	AFYI0v6xAqj4kS57xkM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20xvaj40_
	Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwV
	C0I7IYx2IY6xkF7I0E14v26rxl6s0DM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK
	6I8E87Iv6xkF7I0E14v26rxl6s0DM2kK67kvxFCE548m6r1fGryUXwAac4AC62xK8xCEY4
	vEwIxC4wAqjxCEc2xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	x4A2jsIE14v26r1j6r4UM4x0Y48IcVAKI48JM4IEnf9ElVAFpTB2q-sK649IAas0WaI_Gw
	CjxxvEa2IrMxkIecxEwVAFwVW8AwCY0x0Ix7I2Y4AK6F4j6FyUMxAIw28IcxkI7VAKI48J
	MxCjnVAqn7xvrwC2zVAF1VAY17CE14v26r126r1DMIIF0xvE42xK8VAvwI8IcIk0rVWrZr
	1j6s0DYxBIdaVFxhVjvjDU0xZFpf9x0pEo7K3UUUUU=
X-CM-SenderInfo: 5ilj0iqyqsqiyswou0bp/1tbi3RJVmEsL7vIFawABsx
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi all,

i read the driver/staging/hv code, why it will apply into kernel tree 
that it not fellow the kernel codingstyle?

it ruin the kernel tree, it had better let the author rewrite it fellow 
the "linux kernel CodingStyle".

see Documentation/CodingStyle.

Best,
Figo.zhang

