Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252AbXJUSIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbXJUSIW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 14:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbXJUSIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 14:08:15 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:32300 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751545AbXJUSIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 14:08:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=oV2d++c6oS8/bcRYzucrzGEeXKhEUTzexoxyeQjAasdnP8KMeDP6v0QUAV3sf06DR8fb1c4+4YhJDXKXgkPfZXyASYCbDbThY9a3WX4pWygIkiKuz6uGrLj5oA3G3vPcJmLXmO41ZfTPhj4aAaWI6SDx0Xl7zdliPAnnYZH5dEI=  ;
X-YMail-OSG: SpxPwtkVM1npsjkQJx_5Q_52V82KYHPxi.LAVTiFDaJBmkMvwexIZ3QJJWh9kgVv8XqtgiO5wzXh1JxLcE9b4EU33ySCJh1hctxAMtBuFuKvn8VlJTQ-
Message-ID: <471B9584.4010701@yahoo.com.au>
Date: Mon, 22 Oct 2007 02:08:04 +0800
From: Ben <benjg87@yahoo.com.au>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Problem with reiserfs in 2.6.23-mm1
References: <471A0DF4.50700@yahoo.com.au>
In-Reply-To: <471A0DF4.50700@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ben wrote:
> Hello.
>
> Whenever I log into xfce with gdm my computer will freeze when i use 
> reiserfs as my /home on 2.6.23-mm1. Logging into the VT works 
> perfectly fine. Previously my system would crash when logging into the 
> VT but the
> make-reiserfs-stop-using-struct-file-for-internal.patch patch fixed 
> the issue(and possibly introduced the issue I currently have). My 
> system works perfectly fine using 2.6.23-rc6-mm1 and prior. /home is 
> mounted with the following options: /dev/sda3 on /home type reiserfs 
> (rw,nosuid,nodev,noatime,acl)
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
I just tried mainline 2.6.23 and I have no issues with that.
