Return-Path: <linux-kernel-owner+w=401wt.eu-S1752596AbXBDW6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbXBDW6y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 17:58:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbXBDW6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 17:58:53 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:8649 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbXBDW6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 17:58:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=BRuIfJlqYuqSXCe50iZsftQxFaN27QO46z0A9Ec8MwjmsTDTqa8+Uvyf62vOqbRtyXu4AxTbiGJvCakuqUg9ES7Jeb2qaCApbYBcna1niei6lC2IA/boa3lPh4Nhd0N0iB40l0tCsk0heKfqtJGt1kzNgtEoxXVC1KZNLGD4Sus=
Message-ID: <767314830702041458w58cd41bcn353fd8dbc96dd09e@mail.gmail.com>
Date: Sun, 4 Feb 2007 17:58:51 -0500
From: "Keenan Pepper" <keenanpepper@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Timeouts on ICH7 PATA drive with ata_piix; ide_generic worksperfectly
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> * Does putting in a readable CD or DVD make any difference?

Yes, I ran for an hour with an audio CD in the drive and there were no timeouts.

> * Does the problem occur in single mode where no HAL or whatever is running?

No, there were no timeouts in single mode even without a CD in the drive.

> Auch, scrap the last paragraph. You actually did. Sorry about that. ;-)

Well, partly my fault for letting Gmail give it the wrong MIME type.
Should have made the filenames end in .txt.

> I see your controller is ICH7 and the errors are over ten minutes apart.
> It really seems that HAL, smartd, hddtemp or whatever is poking the dvd
> writer and it isn't happy about it. In addition to the above questions,
> you can read cd/dvd's using the drive, right?

Yes, the optical drive itself works great; I can even burn DVDs.

Keenan
