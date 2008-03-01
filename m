Return-Path: <linux-kernel-owner+w=401wt.eu-S1757758AbYCAT6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758AbYCAT6Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 14:58:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756824AbYCAT6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 14:58:10 -0500
Received: from qmta05.westchester.pa.mail.comcast.net ([76.96.62.48]:60336
	"EHLO QMTA05.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760921AbYCAT6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 14:58:09 -0500
X-Authority-Analysis: v=1.0 c=1 a=Vt2AcnKqAAAA:8 a=4a1OqAhKv9YY8Xs3N4kA:9
 a=D0gB5FNFFy5dV3tGkBusHDpZPSoA:4 a=lBRciGGoxdUA:10 a=JcB9aHnUDh0A:10
Message-ID: <47C9B558.3080004@personnelware.com>
Date: Sat, 01 Mar 2008 13:58:16 -0600
From: Carl Karsten <carl@personnelware.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: please promote multi-qtd URB patch
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Misha Zhilin <[EMAIL PROTECTED]>
Acked-by: Alan Stern <[EMAIL PROTECTED]>
http://www.mail-archive.com/linux-usb@vger.kernel.org/msg01969.html

This patch fixes a bug that is causing problems with a project I am working on. 
    the bug effects a v4l2 driver, having to compile a kernel is making driver 
debugging a big pain.

Getting this patch into Ubuntu's kernel will make things much easier, but:

Stefan Bader <stefan.bader@canonical.com> wrote:
> Since that was even considered for .24 stable release, it will come in
> that way. However, I'd like to wait for this to hit upstream.

If there is anything else I can to to make this happen, let me know.

Thanks,
Carl Karsten
