Return-Path: <linux-kernel-owner+w=401wt.eu-S1761603AbZEMVxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761603AbZEMVxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 17:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbZEMVxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 17:53:36 -0400
Received: from web32405.mail.mud.yahoo.com ([68.142.207.198]:40695 "HELO
	web32405.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753159AbZEMVxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 17:53:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=cNwK0oeoqKM+6SdQSj3AgOeAgPNNAdEVhJpHCT1W0MzGXrYrngi/qAL3OjdZcwGBvFzyyYgFAk9gx4nN+h3ZoXuQgjeL1JsBQHdDzVI7QV3AXeaMHODuPGk4pvr//LrUw1exPhJf3Q3Z/RLTOjXUFQQdwo/Guuu6QJUJGgCyOQM=;
Message-ID: <548601.3000.qm@web32405.mail.mud.yahoo.com>
X-YMail-OSG: CPxLYaQVM1lq43OqDlYxE7ncI9FXd9PqhI6SNaZbCvekIBhKDUkQf8pQnIhsKSzzIMazI0iaUkJxaee.ebC4yOZMZygCFItLrZYBi0oiKmC1iOTzTaXT2bS7Gqj7Zy0lvR8AQ5T4seFDafqWW.DStOQoYXTWggXkrdQ_hf62tV4WgK46n5Z.n1OQBedULgmtafj3UwWJ5DLDMapLXM2rN5pQpTeXmLU9WJ123MW_AdXsNOMSMJ8OvsKVT3SDlyusAhHcFhUJWnlGiXcTwyy1Y7ioEmi63AiEUr2d8Mq5AEmWMedqww0-
X-Mailer: YahooMailClassic/5.2.20 YahooMailWebService/0.7.289.10
Date: Wed, 13 May 2009 14:53:36 -0700 (PDT)
From: Anil kumar <anils_r@yahoo.com>
Subject: send signal with data from driver
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I want to send a event notification from the driver to registered applications. I am using kill_async( ) with SIGIO. But with this I cannot send any data along with the signal. 
Is there a way to send data (buffer or a int number) along with the signal from the driver.

With regards,
  Anil


      
