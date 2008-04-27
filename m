Return-Path: <linux-kernel-owner+w=401wt.eu-S1758880AbYD0PYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880AbYD0PYO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 11:24:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbYD0PX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 11:23:59 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:20572 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbYD0PX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 11:23:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=K6lRomEOF4OlHE6iMR49v+PKR7cWD+quRqJLf9uIw3jTelsCQcc9BWc3CDZUR0bYqaOJcDC5fdT7/J9te8NZ6t8wCS76MWBx4F0FdBPBwXBPVTxXilm3sKFR7A4JgIqmcdOjPzY6qZusya6uQAP5W5EAZJywhUcUNZJ7S/tWRI0=
Message-ID: <e2e108260804270823t45611ec2t35da085833d82dfa@mail.gmail.com>
Date: Sun, 27 Apr 2008 17:23:57 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Sergio Luis" <sergio@larces.uece.br>
Subject: Re: 2.6.25 slow boot/reboot
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <48141111.7010605@larces.uece.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48141111.7010605@larces.uece.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 7:37 AM, Sergio Luis <sergio@larces.uece.br> wrote:
>  This weekend I got some time and decided to try out 2.6.25, but its booting process was _really_ slow in my laptop[1]. With 'old' 2.6.24.5 my machine would take about 48 secs until it gave me the login prompt. And it would take about 22 seconds to reboot.

Do you use LILO or GRUB for booting ? 2.6.25 works OK on the systems I
tested, but LILO really needs a lot of time to load the 2.6.25 kernel.
GRUB loads the 2.6.25 kernel at normal speed.

Bart.
