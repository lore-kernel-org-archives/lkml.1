Return-Path: <linux-kernel-owner+w=401wt.eu-S1758388AbZFCOyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388AbZFCOyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 10:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754903AbZFCOyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 10:54:10 -0400
Received: from web50101.mail.re2.yahoo.com ([206.190.38.29]:40428 "HELO
	web50101.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756925AbZFCOyK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 10:54:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=5Fy9c79FAJuabFs7jUkGZdHjNXZTROS3Ezqm12vbaXk8Ch5HuiCmjjzXhmkUMotSgV/g4tHfYW5uhf5YhOwRlmdqi4oJHVnUEG5NCJ8zfJcVhn+iXt3vUOVoChLIs4QiNAwupSIGS5miJLyl/MN2lBl5VANdG9+T4Us9W1ZvpMo=;
Message-ID: <957183.51083.qm@web50101.mail.re2.yahoo.com>
X-YMail-OSG: la5Ua9UVM1lUcuW1oKejZeY8Gz2FA0w4_ShOuXbKUwYamMHzsRe8nsxZuo7.0ZO_iOWVUbVhWnIjAXlJ3TCRqW.Ol_AwfX7HtqRVlTIOpZN1a_vChQKnnPPo_oZMRWRTRADSBHZrLOL7RMOwfkFNiqBSSSDsz3ZSOyOfEL.b.f5FLX2fk0v2cVgma.LtRr98usFeATq1tTJ.vyewrJ2fLLCtg6QyZuTq9VR4LOl_tpe0I5pBl9uHoXfxkP.xcwxDpnlOLwfSI3WttlsJE6wAOXCQ5kMzYSYys0.h_sMJLe4dzrUeUtd0bPOwav7htYkVwA--
X-Mailer: YahooMailClassic/5.4.12 YahooMailWebService/0.7.289.10
Date: Wed, 3 Jun 2009 07:54:11 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH V2] Fix the meaning of EDAC abbreviation
To: Jiri Kosina <trivial@kernel.org>, leemgs1@gmail.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>, dougthompson@xmission.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- On Wed, 6/3/09, GeunSik Lim <leemgs1@gmail.com> wrote:

> From: GeunSik Lim <leemgs1@gmail.com>
> Subject: [PATCH V2] Fix the meaning of EDAC abbreviation
> To: "Jiri Kosina" <trivial@kernel.org>
> Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, dougthompson@xmission.com, "Alan Cox" <alan@lxorguk.ukuu.org.uk>
> Date: Wednesday, June 3, 2009, 4:12 AM
> 
> 
> 
> Dear Jiri Kosina,
> 
> This is trivial patch.
> I updated description about EDAC in the
> driver/edac/Kconfig. 
> thanks to Alan Cox.  Please, merge this patch. 
>  
>  * Changelogs - V1
>     - Modify original word of EDAC abbreviation.
>        ( http://patchwork.kernel.org/patch/27592/
> )
>  
> 
> 
> Thanks, 
> 
> 
> Subject: [PATCH V2] Fix the meaning of EDAC abbreviation
> 
> Fix the meaning of EDAC(Error Detection And Correction)
> correctly.
>  - http://bluesmoke.sourceforge.net
> 
>         Signed-off-by: GeunSik Lim
> <geunsik.lim@samsung.com>
>         Reviewed-by  : Alan Cox
> <alan@lxorguk.ukuu.org.uk>
> ---
>  drivers/edac/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
> index 956982f..2a81915 100644
> --- a/drivers/edac/Kconfig
> +++ b/drivers/edac/Kconfig
> @@ -5,7 +5,7 @@
>  #
>  
>  menuconfig EDAC
> -    bool "EDAC - error detection and
> reporting"
> +    bool "EDAC(Error Detection And
> Correction) reporting"
>      depends on HAS_IOMEM
>      depends on X86 || PPC
>      help
> -- 
> 1.6.3.1

Ok, even better. It covers both contexts 

doug t

