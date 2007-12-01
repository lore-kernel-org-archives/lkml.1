Return-Path: <linux-kernel-owner+w=401wt.eu-S1754346AbXLASJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbXLASJn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 13:09:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbXLASJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 13:09:35 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:60331 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbXLASJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 13:09:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=B8MSo1/3BHYNYzsiSr/5qZmi4sLkk7NozfUa1EX4HAjeDSIMl3lN/Uv2j4hQl4hVY+AFC5LXxmj7FxXIYqGOOUUyHYSfqn9GyDGolsgJj3qoyweKzELHBNzmceH/DsAOJQ4MYjdkOy3Uf2Sjmz3HPq4/QRmXKFrnNHHrkunXtpA=
Message-ID: <bda6d13a0712011009k13fe4e41u46dcdecd26fca037@mail.gmail.com>
Date: Sat, 1 Dec 2007 10:09:28 -0800
From: "Joshua Hudson" <joshudson@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Executable file format, locating stack?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there an executable file format that can specify things like where
the stack ends up?
Yes, I really do care. I want to put the stack at the top of virtual
address space rather than randomized.
