Return-Path: <linux-kernel-owner+w=401wt.eu-S932113AbZABUuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbZABUuX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 15:50:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758272AbZABUuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 15:50:07 -0500
Received: from web110612.mail.gq1.yahoo.com ([67.195.13.203]:34160 "HELO
	web110612.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757499AbZABUuG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 15:50:06 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=IOXw9jc7Ci9mPDJr1VLEppmpffzwKEnRn+iNBRNEYTJ9FUcsbtTWs/heJ+4BoSuDIYGulpbp481kEw8ZAWTEOjNVEJTj/QC5A1Opq24PzXy+hBb6ZsO1KVh7HCn+qLEW28MJ0JwkkIh+CZDZaK4+T78xwyaUxpRkppD2RysVzjc=;
X-YMail-OSG: QBigH6wVM1lYEgKnQSwIg18D52U4e271sCJRT3VI5jDujy47Bpl.kNyVQDAte0LB2DH3hyS3owvclv2J2u3Os5lNZVva00uyHgPIU.5H4k3PS4VZRhXTnwYNGh7t5s.BjCV4JNPq870NGAvZJF9fKHaopyVkXuj6xza6mGTO02Nhx00OlHTu2KHLyC.4oo.IM9QOuWBveO7Q5m3OSUO.0uI0QyMs.HDqxyokwI8-
X-Mailer: YahooMailRC/1155.45 YahooMailWebService/0.7.260.1
References: <fa.8mwKV7y4hm+Q6mvIKtp9QGoJYUU@ifi.uio.no>  <fa.4QcsYZC0gJJwJ0eUOht3hDYaVWs@ifi.uio.no>  <49580061.9060506@yahoo.com> <87f94c370901021226j40176872h9e5723c6da4afcbe@mail.gmail.com>
Date: Fri, 2 Jan 2009 12:43:22 -0800 (PST)
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: RFC: detection of silent corruption via ATA long sector reads
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Mark Lord <liml@rtr.ca>, Redeeman <redeeman@metanurb.dk>,
       piergiorgio.sartor@nexgo.de, neilb@suse.de, linux-raid@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <124360.23007.qm@web110612.mail.gq1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is there a more comprehensive write-up / resource that describes the
> current status of the overall INTEGRITY support is, especially as it
> relates to ATA devices?


Did you check the kernel notes on kernelnewbies when the feature went in - 
http://kernelnewbies.org/Linux_2_6_27 ?


      
